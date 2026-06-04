from django.shortcuts import render

def cadastrar_view(request):
    return render(request, 'cadastrar/cadastrar.html')