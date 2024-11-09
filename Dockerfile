# Use .NET Core runtime image as base image (for running the application)
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80

# Build stage: Use SDK to build the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy the solution file and restore dependencies first
COPY ./dotnet-hello-world.sln /src/
COPY ./hello-world-api/hello-world-api.csproj /src/hello-world-api/

# Debugging: Check if the files are copied correctly
RUN ls -R /src

# Restore dependencies (this step should be done separately from copying all the files to leverage Docker cache)
RUN dotnet restore /src/dotnet-hello-world.sln --verbosity detailed

# Copy the rest of the application files (this is done after restore to cache dependencies properly)
COPY . /src/

# Debugging: Check the project structure again
RUN ls -R /src

# Set the working directory to where the project is copied and publish the app
WORKDIR /src
RUN dotnet publish /src/hello-world-api/hello-world-api.csproj -c Release -o /app --verbosity detailed

# Final stage: Use the runtime image to run the app
FROM base AS final
WORKDIR /app

# Copy the published files from the build stage
COPY --from=build /app .  # Ensure this matches the output of the publish

# Set the entry point for the application
ENTRYPOINT ["dotnet", "hello-world-api.dll"]
