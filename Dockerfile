# ---
# Image containing the code and sdk
FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS src-env
LABEL env="src"
WORKDIR /src

COPY DockerTest.sln ./
COPY Web/ ./Web
COPY Web.Test/ ./Web.Test
RUN dotnet restore DockerTest.sln

# ---
# Image to build and run tests
FROM src-env as test-env
LABEL env="test"
WORKDIR /src
RUN dotnet test DockerTest.sln

# ---
# Image to build and publish release files
FROM src-env as release-env
LABEL env="release"
WORKDIR /src
RUN dotnet publish ./Web/Web.csproj -c Release -o /publish/web

# ---
# Image to serve the web app from the published files
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS serve-env
LABEL env="serve"
WORKDIR /publish
COPY --from=release-env /publish/web ./web
ENTRYPOINT ["dotnet", "./web/Web.dll"]