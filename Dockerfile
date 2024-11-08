FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

COPY dotnet-hellow-world.proj  
RUN dotnet restore
RUN dotnet publish -c Release -o out

EXPOSE 80
ENTRYPOINT ["dotnet", "dotnet-hello-world.dll"]
