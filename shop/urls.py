from django.urls import path

from . import views

app_name = "shop"
urlpatterns = [
    path("", views.index, name="index"),
    path("course/<int:course_id>/", views.course_detail, name="course_detail"),
]
