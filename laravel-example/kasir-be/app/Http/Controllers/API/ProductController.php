<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    // GET /api/products
    public function index()
    {
        $products = Product::all()->map(function ($product) {
            return [
                'id' => $product->id,
                'name_product' => $product->name_product,
                'stok' => $product->stok,
                'price' => $product->price,
                'img_url' => $product->img ? asset('images/' . $product->img) : null,
            ];
        });

        return response()->json(['data' => $products], 200);
    }

    // POST /api/products
    public function store(Request $request)
    {
        $request->validate([
            'name_product' => 'required|string',
            'stok' => 'required|integer',
            'price' => 'required|integer',
            'img' => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
        ]);

        $filename = null;

        if ($request->hasFile('img')) {
            $file = $request->file('img');
            $filename = time() . '_' . $file->getClientOriginalName();
            $file->move(public_path('images'), $filename);
        }

        $product = Product::create([
            'name_product' => $request->name_product,
            'stok' => $request->stok,
            'price' => $request->price,
            'img' => $filename,
        ]);

        return response()->json([
            'message' => 'Produk berhasil ditambahkan',
            'data' => [
                'id' => $product->id,
                'name_product' => $product->name_product,
                'stok' => $product->stok,
                'price' => $product->price,
                'img_url' => $filename ? asset('images/' . $filename) : null,
            ]
        ], 201);
    }

    // GET /api/products/{id}
    public function show($id)
    {
        $product = Product::find($id);
        if (!$product) {
            return response()->json(['message' => 'Produk tidak ditemukan'], 404);
        }

        return response()->json([
            'data' => [
                'id' => $product->id,
                'name_product' => $product->name_product,
                'stok' => $product->stok,
                'price' => $product->price,
                'img_url' => $product->img ? asset('images/' . $product->img) : null,
            ]
        ], 200);
    }

    // PUT /api/products/{id}
    public function update(Request $request, $id)
    {
        $product = Product::find($id);
        if (!$product) {
            return response()->json(['message' => 'Produk tidak ditemukan'], 404);
        }

        $request->validate([
            'name_product' => 'sometimes|required|string',
            'stok' => 'sometimes|required|integer',
            'price' => 'sometimes|required|integer',
            'img' => 'nullable|image|mimes:jpeg,png,jpg|max:2048',
        ]);

        // Update data
        $product->name_product = $request->name_product ?? $product->name_product;
        $product->stok = $request->stok ?? $product->stok;
        $product->price = $request->price ?? $product->price;

        if ($request->hasFile('img')) {
            // Hapus gambar lama dari public/images
            $oldImagePath = public_path('images/' . $product->img);
            if ($product->img && file_exists($oldImagePath)) {
                unlink($oldImagePath);
            }

            // Simpan gambar baru
            $file = $request->file('img');
            $filename = time() . '_' . $file->getClientOriginalName();
            $file->move(public_path('images'), $filename);
            $product->img = $filename;
        }

        $product->save();

        return response()->json([
            'message' => 'Produk berhasil diperbarui',
            'data' => [
                'id' => $product->id,
                'name_product' => $product->name_product,
                'stok' => $product->stok,
                'price' => $product->price,
                'img_url' => $product->img ? asset('images/' . $product->img) : null,
            ]
        ], 200);
    }

    // DELETE /api/products/{id}
    public function destroy($id)
    {
        $product = Product::find($id);
        if (!$product) {
            return response()->json(['message' => 'Produk tidak ditemukan'], 404);
        }

        // Hapus gambar dari public/images jika ada
        $imagePath = public_path('images/' . $product->img);
        if ($product->img && file_exists($imagePath)) {
            unlink($imagePath);
        }

        $product->delete();

        return response()->json(['message' => 'Produk berhasil dihapus'], 200);
    }
}
