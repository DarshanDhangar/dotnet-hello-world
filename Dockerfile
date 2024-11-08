# Use .NET Core runtime and SDK
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Build stage: Use SDK to build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy the project file and restore dependencies
COPY . /app
WORKDIR /app
RUN dotnet restore dotnet-hello-world.proj

# Copy the rest of the application files and publish
COPY . .
RUN dotnet publish -c Release -o /app/publish

# Final stage: Use the runtime image to run the app
FROM base AS final
WORKDIR /app

# Copy the published files from the build stage
COPY --from=build /app/publish .

# Set the entry point for the application
ENTRYPOINT ["dotnet", "dotnet-hello-world.dll"]
