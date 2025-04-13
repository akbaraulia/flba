<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Payment;

class PaymentController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $payments = Payment::with(['product', 'member', 'user'])->get();

        return response()->json(['data' => $payments]);
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
        $request->validate([
            'product_id' => 'required|exists:products,id',
            'user_id' => 'required|exists:users,id',
            'total_price' => 'required|numeric',
            'pay' => 'required|numeric',
            'change' => 'required|numeric',
            'qty' => 'required|integer|min:1',
            'member_id' => 'nullable|exists:members,id',
        ]);

        $product = \App\Models\Product::find($request->product_id);

        // Cek stok cukup
        if ($product->stok < $request->qty) {
            return response()->json(['message' => 'Stok tidak mencukupi'], 400);
        }

        // Kurangi stok
        $product->stok -= $request->qty;
        $product->save();

        // Simpan transaksi
        $payment = Payment::create([
            'product_id' => $request->product_id,
            'user_id' => $request->user_id,
            'member_id' => $request->member_id,
            'total_price' => $request->total_price,
            'pay' => $request->pay,
            'change' => $request->change,
            'qty' => $request->qty,
        ]);

        return response()->json([
            'message' => 'Pembayaran berhasil disimpan',
            'data' => $payment->load(['product', 'user', 'member']),
        ], 201);
    }



    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $payment = Payment::with(['product', 'member', 'user'])->find($id);

        if (!$payment) {
            return response()->json(['message' => 'Pembayaran tidak ditemukan'], 404);
        }

        return response()->json(['data' => $payment]);
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
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }
}