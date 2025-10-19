from django.db import models
from django.utils import timezone
# Create your models here.

class Category(models.Model):
    # id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=255)
    # created_at = models.DateTimeField(auto_now_add=True)
    created_at = models.DateTimeField(default=timezone.now)

    def __str__(self):
        return self.title

class Course(models.Model):
    # id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=300)
    price = models.FloatField()
    students_qty = models.IntegerField(default=0)
    reviews_qty = models.IntegerField()
    category = models.ForeignKey(Category, on_delete=models.CASCADE)
    created_at = models.DateTimeField(default=timezone.now)

    # reduced_price = models.DecimalField(max_digits=10, decimal_places=2, null=True, blank=True)
    # description = models.TextField()
    # image = models.ImageField(upload_to="courses/")

    def __str__(self):
        return self.title
