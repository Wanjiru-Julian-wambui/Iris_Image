<?php

namespace App\Http\Controllers;

use App\Http\Resources\ImagePollResource;
use App\Http\Resources\ImageResource;
use App\Models\Image;
use App\Models\ImagePoll;
use App\Models\ImagePollVote;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Session;
use Inertia\Inertia;
use Inertia\Response;

class ImagePollController extends Controller
{
    public function __construct()
    {
        $this->middleware(['auth', 'admin'])->only(['index', 'create', 'store', 'destroy']);
        // show and vote are fully public — no middleware
    }

    public function index(Request $request): Response
    {
        $polls = $request->user()
            ->polls()
            ->with(['imageA', 'imageB', 'images'])
            ->latest()
            ->paginate(12);

        return Inertia::render('polls/Index', [
            'polls' => ImagePollResource::collection($polls),
        ]);
    }

    public function create(Request $request): Response
    {
        $images = $request->user()
            ->images()
            ->orderBy('created_at', 'desc')
            ->get();

        return Inertia::render('polls/Create', [
            'images' => ImageResource::collection($images),
        ]);
    }

    public function store(Request $request)
    {
        $data = $request->validate([
            'type'         => ['required', 'in:ab,multi'],
            'question'     => ['required', 'string', 'max:200'],

            // A/B specific
            'image_a_id'   => ['required_if:type,ab', 'nullable', 'integer', 'exists:images,id'],
            'image_b_id'   => ['required_if:type,ab', 'nullable', 'integer', 'exists:images,id', 'different:image_a_id'],

            // Multi specific
            'image_ids'    => ['required_if:type,multi', 'nullable', 'array', 'min:2'],
            'image_ids.*'  => ['integer', 'exists:images,id'],
            'max_choices'  => ['nullable', 'integer', 'min:1'],
        ]);

        $userId = $request->user()->id;

        if ($data['type'] === 'ab') {
            $imageA = Image::findOrFail($data['image_a_id']);
            $imageB = Image::findOrFail($data['image_b_id']);
            abort_unless($imageA->user_id === $userId, 403);
            abort_unless($imageB->user_id === $userId, 403);

            $poll = $request->user()->polls()->create([
                'type'       => 'ab',
                'question'   => $data['question'],
                'image_a_id' => $data['image_a_id'],
                'image_b_id' => $data['image_b_id'],
            ]);
        } else {
            $imageIds = array_unique($data['image_ids']);

            $count = Image::whereIn('id', $imageIds)->where('user_id', $userId)->count();
            abort_unless($count === count($imageIds), 403);

            $poll = DB::transaction(function () use ($request, $data, $imageIds) {
                $poll = $request->user()->polls()->create([
                    'type'        => 'multi',
                    'question'    => $data['question'],
                    'max_choices' => $data['max_choices'] ?? null,
                ]);

                $pivot = [];
                foreach (array_values($imageIds) as $i => $imageId) {
                    $pivot[$imageId] = ['sort_order' => $i];
                }
                $poll->images()->attach($pivot);

                return $poll;
            });
        }

        return redirect()->route('polls.show', $poll->public_token)
            ->with('success', 'Poll created!');
    }

    public function show(string $token)
    {
        $poll = ImagePoll::where('public_token', $token)
            ->with(['imageA', 'imageB', 'images', 'votes', 'multiVotes'])
            ->firstOrFail();

        $userId      = auth()->id();
        $ip          = request()->ip();
        $fingerprint = $this->getFingerprint();
        $hasVoted    = $poll->hasVoted($ip, $fingerprint, $userId);

        $userVote  = null;
        $userVotes = null;

        if ($hasVoted) {
            if ($poll->isAb()) {
                $vote = $poll->votes()
                    ->when($userId, fn($q) => $q->where('user_id', $userId))
                    ->when(!$userId, fn($q) => $q->where('ip_address', $ip)->where('session_fingerprint', $fingerprint))
                    ->first();
                $userVote = $vote?->choice;
            } else {
                $userVotes = $poll->multiVotes()
                    ->when($userId, fn($q) => $q->where('user_id', $userId))
                    ->when(!$userId, fn($q) => $q->where('ip_address', $ip)->where('session_fingerprint', $fingerprint))
                    ->pluck('image_id')
                    ->all();
            }
        }

        $poll->setAttribute('has_voted', $hasVoted);
        $poll->setAttribute('user_vote', $userVote);
        $poll->setAttribute('user_votes', $userVotes);

        return Inertia::render('polls/Show', [
            'poll' => new ImagePollResource($poll),
        ]);
    }

    public function vote(Request $request, string $token)
    {
        $poll        = ImagePoll::where('public_token', $token)->firstOrFail();
        $userId      = auth()->id();
        $ip          = $request->ip();
        $fingerprint = $this->getFingerprint();

        if ($poll->hasVoted($ip, $fingerprint, $userId)) {
            return back()->with('error', 'You have already voted in this poll.');
        }

        if ($poll->isAb()) {
            $data = $request->validate([
                'choice' => ['required', 'in:a,b'],
            ]);

            $poll->votes()->create([
                'choice'              => $data['choice'],
                'user_id'             => $userId,
                'ip_address'          => $ip,
                'session_fingerprint' => $fingerprint,
            ]);
        } else {
            $data = $request->validate([
                'image_ids'   => ['required', 'array', 'min:1'],
                'image_ids.*' => ['integer'],
            ]);

            $validIds = $poll->images()->pluck('images.id')->all();
            $chosen   = array_unique(array_intersect($data['image_ids'], $validIds));

            if (empty($chosen)) {
                return back()->with('error', 'Please select at least one image.');
            }

            if ($poll->max_choices && count($chosen) > $poll->max_choices) {
                return back()->with('error', "You can only pick up to {$poll->max_choices} image(s).");
            }

            DB::transaction(function () use ($poll, $chosen, $userId, $ip, $fingerprint) {
                foreach ($chosen as $imageId) {
                    $poll->multiVotes()->create([
                        'image_id'            => $imageId,
                        'user_id'             => $userId,
                        'ip_address'          => $ip,
                        'session_fingerprint' => $fingerprint,
                    ]);
                }
            });
        }

        return back()->with('success', 'Vote recorded!');
    }

    public function destroy(ImagePoll $poll)
    {
        abort_unless($poll->user_id === auth()->id(), 403);
        $poll->delete();
        return redirect()->route('polls.index')->with('success', 'Poll deleted.');
    }

    private function getFingerprint(): string
    {
        $sessionId = Session::getId();
        $userAgent = substr(request()->userAgent() ?? 'unknown', 0, 100);
        return hash('sha256', $sessionId . $userAgent);
    }
}