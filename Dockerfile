FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster  AS build
WORKDIR /app
# copy csproj and restore as distinct layers
COPY *.sln .
COPY APIGateway/*.csproj ./APIGateway/
RUN dotnet restore

# copy everything else and build app
COPY APIGateway/. ./APIGateway/
WORKDIR /app/APIGateway
RUN dotnet publish -c Release -o out


FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim
WORKDIR /app
COPY --from=build /app/APIGateway/out ./
ENTRYPOINT ["dotnet", "APIGateway.dll"]