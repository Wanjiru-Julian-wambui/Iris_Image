<?php

namespace App\Http\Controllers;

use App\Http\Resources\ImagePollResource;
use App\Http\Resources\ImageResource;
use App\Models\Image;
use App\Models\ImagePoll;
use App\Models\ImagePollVote;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Session;
use Inertia\Inertia;
use Inertia\Response;

class ImagePollController extends Controller
{
    public function index(Request $request): Response
    {
        $polls = $request->user()
            ->polls()
            ->with(['imageA', 'imageB'])
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
            'question'     => ['required', 'string', 'max:200'],
            'image_a_id'   => ['required', 'integer', 'exists:images,id'],
            'image_b_id'   => ['required', 'integer', 'exists:images,id', 'different:image_a_id'],
        ]);

        $imageA = Image::findOrFail($data['image_a_id']);
        $imageB = Image::findOrFail($data['image_b_id']);

        abort_unless($imageA->user_id === $request->user()->id, 403);
        abort_unless($imageB->user_id === $request->user()->id, 403);

        $poll = $request->user()->polls()->create([
            'question'   => $data['question'],
            'image_a_id' => $data['image_a_id'],
            'image_b_id' => $data['image_b_id'],
        ]);

        return redirect()->route('polls.show', $poll->public_token)
            ->with('success', 'Poll created!');
    }

    public function show(string $token)
    {
        $poll = ImagePoll::where('public_token', $token)
            ->with(['imageA', 'imageB', 'votes'])
            ->firstOrFail();

        $userId = auth()->id();
        $ip = request()->ip();
        $fingerprint = $this->getFingerprint();

        $hasVoted = $poll->hasVoted($ip, $fingerprint, $userId);
        $userVote = null;

        if ($hasVoted) {
            $vote = $poll->votes()
                ->when($userId, fn($q) => $q->where('user_id', $userId))
                ->when(!$userId, fn($q) => $q->where('ip_address', $ip)->where('session_fingerprint', $fingerprint))
                ->first();
            $userVote = $vote?->choice;
        }

        $poll->setAttribute('has_voted', $hasVoted);
        $poll->setAttribute('user_vote', $userVote);

        return Inertia::render('polls/Show', [
            'poll' => new ImagePollResource($poll),
        ]);
    }

    public function vote(Request $request, string $token)
    {
        $poll = ImagePoll::where('public_token', $token)->firstOrFail();

        $data = $request->validate([
            'choice' => ['required', 'in:a,b'],
        ]);

        $userId = auth()->id();
        $ip = $request->ip();
        $fingerprint = $this->getFingerprint();

        if ($poll->hasVoted($ip, $fingerprint, $userId)) {
            return back()->with('error', 'You have already voted in this poll.');
        }

        $poll->votes()->create([
            'choice'              => $data['choice'],
            'user_id'             => $userId,
            'ip_address'          => $ip,
            'session_fingerprint' => $fingerprint,
        ]);

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