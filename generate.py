import os

files = [
    "pom.xml",
    "Dockerfile",
    ".dockerignore",
    "fly.toml",
    "src/main/resources/application.properties",
    "src/main/resources/application-dev.properties",
    "src/main/resources/application-prod.properties",
    "src/main/java/com/hackathon/service/FileStorageService.java",
    "src/main/java/com/hackathon/service/LocalFileStorageService.java",
    "src/main/java/com/hackathon/service/S3StorageService.java",
    "src/main/java/com/hackathon/config/RateLimiterFilter.java",
    "src/main/java/com/hackathon/config/WebMvcConfig.java",
    "src/main/java/com/hackathon/controller/api/ExternalAchievementRestController.java",
    "src/main/java/com/hackathon/config/BootstrapAdminRunner.java"
]

with open("/home/mojez-hasan/.gemini/antigravity/brain/63a3e25d-7d48-4ad0-bc74-8f9545640e16/deployment_files.md", "w") as out:
    out.write("# Deployment Files\n\nThis document contains all the generated code files for your review before deploying.\n\n")
    for f in files:
        out.write(f"## {os.path.basename(f)}\n")
        ext = os.path.splitext(f)[1][1:]
        if ext == "xml": lang = "xml"
        elif ext == "toml": lang = "toml"
        elif ext == "properties": lang = "properties"
        elif ext == "java": lang = "java"
        elif "Dockerfile" in f: lang = "dockerfile"
        else: lang = ""
        out.write(f"```{lang}\n")
        try:
            with open(f, "r") as inf:
                out.write(inf.read())
        except Exception as e:
            out.write(f"Error reading file: {e}\n")
        out.write("\n```\n\n")
