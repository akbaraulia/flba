<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Payment;
use Carbon\Carbon;

class PaymentController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $payments = Payment::with(['product', 'member', 'user'])
            ->orderBy('created_at', 'desc')
            ->get()
            ->groupBy(function ($item) {
                // Format waktu supaya jadi kunci yang unik per transaksi
                return $item->created_at->format('Y-m-d H:i:s');
            });

        // Format ulang untuk JSON response
        $grouped = $payments->map(function ($items, $timestamp) {
            return [
                'created_at' => $timestamp,
                'total_price' => $items->first()->total_price,
                'pay' => $items->first()->pay,
                'change' => $items->first()->change,
                'user' => $items->first()->user,
                'member' => $items->first()->member,
                'items' => $items->map(function ($item) {
                    return [
                        'product' => $item->product,
                        'qty' => $item->qty,
                    ];
                })->values(),
            ];
        })->values(); // Remove key timestamps

        return response()->json([
            'data' => $grouped
        ]);
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
     * Get the total number of unique buyers today.
     */
    public function getJumlahPembeliHariIni()
    {
        $jumlahPembeli = Payment::whereDate('created_at', Carbon::today())
            ->groupBy('user_id')  // Mengelompokkan berdasarkan user_id
            ->count('user_id');  // Hitung jumlah user unik yang melakukan transaksi

        return response()->json([
            'jumlah_pembeli' => $jumlahPembeli
        ]);
    }

    public function getPenjualan15HariTerakhir()
    {
        $penjualan = Payment::where('created_at', '>=', Carbon::now()->subDays(14))
            ->selectRaw('DATE(created_at) as date, SUM(total_price) as total_penjualan')
            ->groupBy('date')
            ->orderBy('date', 'asc')
            ->get();

        return response()->json([
            'penjualan_15_hari' => $penjualan
        ]);
    }


    public function getPersentasePenjualanProduk()
    {
        $penjualanProduk = Payment::join('products', 'payments.product_id', '=', 'products.id')
            ->selectRaw('products.name_product, SUM(payments.qty) as total_terjual')
            ->groupBy('products.name_product')
            ->orderByDesc('total_terjual')
            ->get();

        return response()->json([
            'penjualan_produk' => $penjualanProduk
        ]);
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
