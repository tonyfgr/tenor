# Usa la imagen de .NET SDK para la fase de construcción
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build 

# Establece el directorio de trabajo dentro del contenedor
WORKDIR /src

# Copia el archivo de proyecto al contenedor
COPY api-02.csproj .

# Restaura las dependencias del proyecto
RUN dotnet restore

# Copia todos los archivos del proyecto al contenedor
COPY . .

# Publica la aplicación en modo de lanzamiento (release)
RUN dotnet publish -c Release -o /app

# Usa la imagen de ASP.NET Runtime para la fase final
FROM mcr.microsoft.com/dotnet/aspnet:8.0 

# Establece el directorio de trabajo para la aplicación
WORKDIR /app

# Copia los archivos publicados desde la fase de construcción
COPY --from=build /app .

# Configura el punto de entrada para ejecutar la aplicación
ENTRYPOINT ["dotnet", "api-02.dll"]
