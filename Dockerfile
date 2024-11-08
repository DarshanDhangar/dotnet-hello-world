# Use .NET Core runtime and SDK
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY dotnet-hellow-world.proj
RUN dotnet restore
RUN dotnet publish -c Release -o /app/publish

FROM base AS final
WORKDIR /app

ENTRYPOINT ["dotnet", "dotnet-hello-world.dll"]
