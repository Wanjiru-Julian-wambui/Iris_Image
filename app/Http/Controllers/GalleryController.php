<?php

namespace App\Http\Controllers;

use App\Http\Resources\ImageResource;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Inertia\Inertia;

class GalleryController extends Controller
{
    public function index(Request $request)
    {
        $query = Auth::user()
            ->images()
            ->latest();

        // Search by filename
        if ($search = $request->input('search')) {
            $query->where('name', 'like', '%' . $search . '%');
        }

        // Sorting
        $sort = $request->input('sort', 'latest');
        match ($sort) {
            'oldest'   => $query->reorder('created_at', 'asc'),
            'largest'  => $query->reorder('size', 'desc'),
            'smallest' => $query->reorder('size', 'asc'),
            'name'     => $query->reorder('name', 'asc'),
            default    => $query->reorder('created_at', 'desc'), // latest
        };

        $images = $query->paginate(40)->withQueryString();

        return Inertia::render('Gallery', [
            'images' => [
                'data'  => ImageResource::collection($images)->resolve(),
                'meta'  => [
                    'current_page' => $images->currentPage(),
                    'last_page'    => $images->lastPage(),
                    'total'        => $images->total(),
                ],
                'links' => [
                    'next' => $images->nextPageUrl(),
                    'prev' => $images->previousPageUrl(),
                ],
            ],
            'filters' => [
                'search' => $request->input('search', ''),
                'sort'   => $sort,
            ],
        ]);
    }
}