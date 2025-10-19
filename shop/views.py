from django.shortcuts import render
from django.http import HttpResponse
from .models import Category, Course
# Create your views here.

def index(request):
    # return render(request, "shop/index.html")
    courses = Course.objects.all()
    return HttpResponse([str(course)+'<br/>' for course in courses])
    # return render(request, "shop/index.html", {"courses": courses})
