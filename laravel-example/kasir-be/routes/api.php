<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\API\ProductController;
use App\Http\Controllers\API\UserController;
use App\Http\Controllers\API\PaymentController;
use App\Http\Controllers\API\MemberController;

Route::post('/login', [AuthController::class, 'login']);
Route::middleware('auth:sanctum')->post('/logout', [AuthController::class, 'logout']);

Route::middleware('auth:sanctum')->group(function () {
    Route::apiResource('products', ProductController::class);
    Route::apiResource('users', UserController::class);
    Route::apiResource('payments', PaymentController::class);
    Route::apiResource('members', MemberController::class);
    Route::post('/members/find', [MemberController::class, 'findByPhone']);
    Route::get('/dashboard/jumlah-pembeli-hari-ini', [PaymentController::class, 'getJumlahPembeliHariIni']);
    Route::get('/dashboard/persentase-penjualan-produk', [PaymentController::class, 'getPersentasePenjualanProduk']);
    Route::get('/dashboard/penjualan-15-hari-terakhir', [PaymentController::class, 'getPenjualan15HariTerakhir']);
});

Route::fallback(function () {
    return response()->json([
        'message' => 'Endpoint tidak ditemukan.'
    ], 404);
});
