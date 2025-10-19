#!/usr/bin/env python
"""
Скрипт для генерации SECRET_KEY для Django.
Использование: python generate_secret_key.py
"""

from django.core.management.utils import get_random_secret_key

if __name__ == "__main__":
    secret_key = get_random_secret_key()
    print("=" * 80)
    print("Сгенерированный SECRET_KEY для Django:")
    print("=" * 80)
    print(secret_key)
    print("=" * 80)
    print("\nДобавьте его в ваш .env файл:")
    print(f"SECRET_KEY={secret_key}")
    print("\nВНИМАНИЕ: Храните этот ключ в секрете и не публикуйте его!")

