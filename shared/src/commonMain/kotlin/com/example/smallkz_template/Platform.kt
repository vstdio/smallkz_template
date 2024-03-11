package com.example.smallkz_template

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform