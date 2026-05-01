# Stage 1: Build the app
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src
# Copy project file and restore dependencies
COPY ["DevOpsDemo.csproj", "."]
RUN dotnet restore "DevOpsDemo.csproj"
# Copy everything else and build
COPY . .
RUN dotnet publish "DevOpsDemo.csproj" -c Release -o /app

# Stage 2: Run the app
FROM mcr.microsoft.com/dotnet/aspnet:10.0
WORKDIR /app
COPY --from=build /app .

# SQLite needs write permissions in the container
USER root
RUN touch app.db && chmod 666 app.db

# Standard port for .NET 10 is 8080 inside the container
EXPOSE 8080
ENTRYPOINT ["dotnet", "DevOpsDemo.dll"]