# base image
FROM mcr.microsoft.com/dotnet/sdk:6.0 as base
# update Image
RUN apt-get update
# download NPM
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
# Install Nodejs
RUN apt-get install -y nodejs

COPY DotnetTemplate.Web /DotnetTemplate.Web
WORKDIR /DotnetTemplate.Web


FROM mcr.microsoft.com/dotnet/sdk:6.0 AS app
WORKDIR /source

# copy csproj and restore as distinct layers
COPY DotnetTemplate.Web/*.csproj .

# copy everything else and build app
COPY DotnetTemplate.Web/. .
RUN dotnet publish -c Release -o /app --use-current-runtime --self-contained false --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app .
ENTRYPOINT ["dotnet", "DotnetTemplate.Web.dll"]

# docker build --tag m8 .
# docker run -p 5000:5000 m8
# docker run -d -p 5000:5000 m8
# docker tag m8 wishy78/dotnettemplate:m8
# docker push wishy78/dotnettemplate:m8
