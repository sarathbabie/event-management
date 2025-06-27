<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\AuthController;
use App\Http\Controllers\Api\EventController;

Route::post('/login', [AuthController::class, 'login']);

Route::middleware('auth:sanctum')->group(function () {

    Route::get('/events', [EventController::class, 'index']); // anyone

    Route::middleware(['IsAdmin'])->group(function () {
        Route::post('/events', [EventController::class, 'store']);
        Route::delete('/events/{id}', [EventController::class, 'destroy']);
    });
    // logout 
    Route::post('/logout', [AuthController::class, 'logout']);
});