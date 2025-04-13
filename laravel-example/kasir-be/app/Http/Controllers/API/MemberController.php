<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Member;
use Illuminate\Support\Facades\Log;
class MemberController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        return response()->json(Member::all(), 200);
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'phone_number' => 'required|string|max:20',
            'point' => 'required|integer|min:0',
        ]);

        $member = Member::create($validated);

        return response()->json($member, 201);
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $member = Member::find($id);

        if (!$member) {
            return response()->json(['message' => 'Member tidak ditemukan'], 404);
        }

        return response()->json($member, 200);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $member = Member::find($id);

        if (!$member) {
            return response()->json(['message' => 'Member tidak ditemukan'], 404);
        }

        $validated = $request->validate([
            'name' => 'required|string|max:255',
            'phone_number' => 'required|string|max:20',
            'point' => 'required|integer|min:0',
        ]);

        $member->update($validated);

        return response()->json($member, 200);
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }

    public function findByPhone(Request $request)
    {

        Log::info('Request FindByPhone', [
            'url' => $request->fullUrl(),
            'phone_number' => $request->phone_number,
        ]);
        $request->validate([
            'phone_number' => 'required|string',
        ]);

        $member = Member::where('phone_number', $request->phone_number)->first();

        if (!$member) {
            return response()->json(['message' => 'Member tidak ditemukan'], 404);
        }

        return response()->json($member);
    }
}
