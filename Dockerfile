# base image
FROM mcr.microsoft.com/dotnet/sdk:6.0 as base
# update Image
RUN apt-get update
# download NPM
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
# Install Nodejs
RUN apt-get install -y nodejs

WORKDIR /app
COPY DotnetTemplate.Web ./
RUN dotnet publish -c Release -o /dist --use-current-runtime --self-contained false

FROM mcr.microsoft.com/dotnet/aspnet:6.0
#copy the dlls that were built
COPY --from=base /dist /dist
WORKDIR /dist
ENTRYPOINT ["dotnet", "DotnetTemplate.Web.dll"]

# docker build --tag m8 .
# docker run -p 5000:5000 m8
# docker run -d -p 5000:5000 m8
# docker tag m8 wishy78/dotnettemplate:m8
# docker push wishy78/dotnettemplate:m8



