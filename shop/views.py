from django.shortcuts import render, get_object_or_404
from django.http import Http404, HttpResponse
from .models import Category, Course
# Create your views here.

def index(request):
    # return render(request, "shop/templates/index.html")
    courses = Course.objects.all()
    # return HttpResponse([str(course)+'<br/>' for course in courses])
    return render(request, "shop/course.html", {"courses": courses, "title": "Courses"})

def course_detail(request, course_id):
    # try:
    #     # course = Course.objects.get(id=course_id)
    #     course = Course.objects.get(pk=course_id)
    #     return render(request, "course_detail.html", {"course": course, "title": course.title})
    # except Course.DoesNotExist:
    #     # raise Http404("Course not found")
    #     return HttpResponse("Course not found", status=404)

    course = get_object_or_404(Course, pk=course_id)
    return render(request, "shop/course_detail.html", {"course": course, "title": course.title})

# def category_detail(request, category_id):
#     category = Category.objects.get(pk=category_id)
#     return render(request, "category_detail.html", {"category": category, "title": category.title})
