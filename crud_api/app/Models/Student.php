<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Student extends Model
{
    use HasFactory;

    protected $fillable = [
        'firstName', 
        'lastName', 
        'course', 
        'year', 
        'enrolled'
    ];
    protected $casts = [
        'enrolled' => 'boolean'
    ];
}
