# graalvm

GraalVM **native-image** AOT compiler for Java — Maven/Gradle with auto-detected targets.

Plugin ID: **`coditary/graalvm`**

## Install

```lua
reqpack { beez = { { name = "coditary/graalvm", version = "1.0.0", source = "github:Coditary/beez-graalvm" } } }
```

## Usage

```lua
configure({ { "coditary/graalvm", {} } })
```

```bash
beez -p setup[native]      # resolve Maven/Gradle dependencies
beez -p compile[native]    # package JAR + native-image AOT
beez -p bundle[native]    # verify native binary in build/graalvm/bin/
beez -p test[test]         # run Maven/Gradle unit tests
```

## Requirements

- GraalVM with `native-image` on `PATH`
- Maven (`mvn`) or Gradle (`gradle` / `./gradlew`) depending on project markers

## Detection

Auto-detects Java projects via:

- `pom.xml` (Maven)
- `build.gradle` / `build.gradle.kts` (Gradle)
- `**/*.java`
- `META-INF/native-image/**` (reflection/resource config)

Output binaries are written to **`build/graalvm/bin/`**.

## Configuration

```lua
configure({
  { "coditary/graalvm", {
      output_name = "myapp",
      jar_path = "target/myapp-1.0.jar",
      main_class = "com.example.Main",
      native_image_args = { "--no-fallback", "-O3" },
  }},
})
```

## License

Apache License 2.0.
