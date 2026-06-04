from django.urls import path
from .views import cadastrar_view

urlpatterns = [
    path('', cadastrar_view, name='cadastrar'),
]
