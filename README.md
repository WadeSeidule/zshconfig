### `zc` Command-Line Tool

`zc` is a modular framework for managing Zsh configurations, designed to help users organize, customize, and optimize their shell environments. It provides tools to manage global settings, create workspace-specific configurations, and dynamically switch between configurations tailored for different projects, teams, or contexts.

---

### Key Features

- **Centralized Configuration Management**: Keep your Zsh environment clean and organized by consolidating settings under a single framework.
- **Workspace-Specific Configurations**: Use `zc workconfig` to create isolated configuration workspaces for different projects or tasks, ensuring modularity and flexibility.
- **Dynamic Environment Switching**: Easily activate and deactivate workspaces, allowing you to adapt your shell environment on the fly.
- **Extensible and Customizable**: Add your own scripts and settings to the framework for complete control over your Zsh setup.

---

### Example Workflow

1. **Set Up the Framework**:
   Initialize your environment with:
   ```bash
   zc setup
   ```
   This backs up your existing `.zshrc` and links your shell to the `zc` framework.

2. **Create a Workspace**:
   Define a new workspace for a specific project:
   ```bash
   zc workconfig create <workname>
   ```

3. **Activate a Workspace**:
   Switch to the new workspace:
   ```bash
   zc workconfig activate <workname>
   ```

4. **Manage Active Workspaces**:
   List all active workspaces:
   ```bash
   zc workconfig list
   ```

5. **Customize Your Environment**:
   Edit modular files in each workspace (`functions`, `aliases`, `exports`, `secrets`) to tailor settings for your needs. Or add any new files or customizable organization.

---

### Why Use `zc`?

- Easy switching between different development environments and machines while keeping shared global configuration.
- Simplifies managing complex Zsh setups with modular files.
- Keeps configurations clean and workspace-specific.
- Enhances productivity by enabling quick environment switching.
- Reduces conflicts between different project or team setups.

---

### Installation

#### 1. Clone the Repository
Clone the repository to your local machine

#### 2. Set the `ZSH_CONFIG_DIR` Environment Variable
Export the `ZSH_CONFIG_DIR` environment variable to point to the cloned directory:
```bash
echo 'export ZSH_CONFIG_DIR=~/zsh-config' >> ~/.zshrc
```

#### 3. Add `ZSH_CONFIG_DIR` to Your `PATH`
Add `ZSH_CONFIG_DIR` is included in your `PATH`:
```bash
echo 'export PATH="$ZSH_CONFIG_DIR:$PATH"' >> ~/.zshrc
```

#### 4. Make Sure the Scripts Are Executable
Ensure all scripts in the cloned directory are executable:
```bash
chmod +x $ZSH_CONFIG_DIR/*
```

---

### Usage

Once installed, you can execute scripts using the `zc` command followed by the command name.

#### `zc setup`

The `zc setup` command initializes your Zsh environment with the `zshconfig` framework. It backs up your existing `.zshrc` (if present), creates a new `.zshrc` linked to the framework, and sets up a modular configuration system for easy customization.

1. Run the setup command:
   ```bash
   zc setup
   ```

2. Reload your shell to apply changes:
   ```bash
   exec zsh
   ```

#### `zc workconfig`

The `zc workconfig` command manages work-specific Zsh configurations, allowing you to create, activate, deactivate, edit, and list configurations for different work environments. Configurations are stored in the `workconfigs` directory under the `ZSH_CONFIG_DIR`.

##### Features

1. **Create a Work Config**: Initialize a new work configuration with default files for functions, aliases, exports, and secrets.
2. **Activate a Work Config**: Enable a specific configuration and add it to the active list.
3. **Deactivate a Work Config**: Remove a configuration from the active list.
4. **Edit a Work Config**: Open a work config directory in your editor.
5. **List Active Configs**: Display currently active configurations.

---

##### Create a New Work Config
```bash
zc workconfig create <workname>
```
Creates a new directory for `<workname>` under `workconfigs` with default Zsh files.

##### Activate a Work Config
```bash
zc workconfig activate <workname>
```
Marks `<workname>` as active by adding it to the active configs list. This will cause all the zsh configuration files under that directory to be sourced after the global configurations. Activating an already-active config is a no-op.

##### Deactivate a Work Config
```bash
zc workconfig deactivate <workname>
```
Removes `<workname>` from the active configs list. Will no longer be sourced.

##### Edit a Work Config
```bash
zc workconfig edit <workname>
```
Opens the `<workname>` config directory in your editor (`$EDITOR`, defaults to `code`).

##### List Active Work Configs
```bash
zc workconfig list
```
Displays all currently active work configurations and all available configs.

##### Display Help
```bash
zc workconfig help
```
Shows usage instructions.

---

#### `zc doctor`

Validates your zsh config setup and checks for expected tools. Useful on a fresh machine to see what's missing.

```bash
zc doctor
```

Checks:
- Framework files and directories
- Oh-My-Zsh and custom plugins
- Core tools (git, nvim, curl)
- Python toolchain (python3, uv, pyenv, poetry)
- Node toolchain (node, npm, nvm, yarn)
- Kubernetes & cloud tools (kubectl, helm, aws, docker)
- Other tools (fzf, fd, autojump)
- Active work config validity

---

#### `zc profile`

Profiles your shell startup time with a per-file breakdown to identify bottlenecks.

```bash
zc profile
```

Reports total interactive shell startup time (best of 3 runs) and times each sourced config file, sorted slowest first.

---

### Lazy Loading

`nvm` and `pyenv` are lazy-loaded by default — they only initialize on first use of their commands (e.g., `node`, `npm`, `pyenv`, `python3`). This can save 200-400ms of shell startup time. The lazy loading is transparent: the first invocation triggers initialization, then the command runs normally.
