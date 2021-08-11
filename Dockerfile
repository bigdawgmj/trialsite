FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR webapp

# Install node
RUN apt update && apt upgrade -y
RUN apt install -y nodejs npm

# copy csproj file and restore
COPY ./*.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . .
RUN dotnet publish -c Release -o out

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /webapp
COPY --from=build /webapp/out .
ENTRYPOINT ["dotnet", "trialsite.dll"]
