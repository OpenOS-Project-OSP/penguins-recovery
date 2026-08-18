[update-readmes]   Mode: rewrite — migrating to template structure...
# penguins-recovery

[![Built with Ona](https://ona.com/build-with-ona.svg)](https://app.ona.com/#https://github.com/OpenOS-Project-OSP/penguins-recovery) [![KDE Eco](https://img.shields.io/badge/KDE%20Eco-certified-brightgreen?logo=kde&logoColor=white&style=flat-square)](https://eco.kde.org/) [![Blue Angel](https://img.shields.io/badge/Blue%20Angel-DE--UZ%20215-0055a4?style=flat-square)](https://www.blauer-engel.de/en/certification/criteria) [![Energy](https://api.green-coding.io/v1/ci/badge/get?repo=OpenOS-Project-OSP%2Fpenguins-recovery&branch=main&workflow=eco-audit.yml)](https://metrics.green-coding.io/ci-index.html)


<!-- AI:start:what-it-does -->
This project provides a unified Linux system recovery toolkit designed for system administrators and advanced users. It addresses the need for creating modular, customizable recovery environments by supporting pluggable builders for Debian, Arch, and Unified Kernel Images (UKI). The toolkit integrates with penguins-eggs and includes utilities for bootloader packaging, secure boot signing, and filesystem recovery.
<!-- AI:end:what-it-does -->

## Architecture

<!-- AI:start:architecture -->
The project uses a modular architecture to build Linux system recovery toolkits. Key components include pluggable builders for Debian, Arch, and Unified Kernel Images (UKI), as well as integration with penguins-eggs for system recovery. Builders are standalone scripts or tools located in the `builders/` directory, each responsible for creating specific recovery artifacts. The `Makefile` orchestrates these builders and provides targets for building, packaging, and verifying recovery images. The `gui/` directory contains the QML-based graphical interface, while `common/` and `tools/` house shared utilities and scripts. Integration tasks and workflows are managed via GitHub Actions in the `.github/` directory.

Directory structure:
```plaintext
.
├── .github/               # CI/CD workflows
├── adapters/              # System-specific adapters
├── bin/                   # Executable scripts
├── bootloaders/           # Bootloader packaging and source
├── builders/              # Pluggable recovery builders
│   ├── debian/            # Debian-based ISO builder
│   ├── arch/              # Arch-based ISO builder
│   ├── uki/               # UKI builder
│   ├── uki-lite/          # Lightweight UKI builder
│   ├── verity-uki/        # Verified UKI builder
├── common/                # Shared utilities
├── gui/                   # QML-based graphical interface
├── recovery-manager/      # Recovery management tools
├── scripts/               # Helper scripts
├── tests/                 # Test cases
├── tools/                 # Additional tools
├── LICENSE                # License file
├── Makefile               # Build orchestration
└── README.md              # Project documentation
```
<!-- AI:end:architecture -->

## Install

<!-- Add installation instructions here. This section is yours — the AI will not modify it. -->

```bash
git clone https://github.com/Interested-Deving-1896/penguins-recovery.git
cd penguins-recovery
```

## Usage

<!-- Add usage examples here. This section is yours — the AI will not modify it. -->

## Configuration

<!-- Document configuration options here. This section is yours — the AI will not modify it. -->

## CI

<!-- AI:start:ci -->
The repository uses GitHub Actions for continuous integration and automation. Below are the workflows and their functions:

- **bootloaders-upstream-sync.yaml**: Synchronizes bootloader sources from upstream repositories. No secrets required.
- **mirror-osp-to-ooc.yaml**: Mirrors the repository from the open-source platform (OSP) to an organizational open-source copy (OOC). Requires `OOC_REPO_TOKEN` secret for authentication.
- **trigger-artifact-mirror.yml**: Triggers artifact mirroring to external storage or repositories. Requires `ARTIFACT_STORAGE_KEY` and `ARTIFACT_STORAGE_SECRET` secrets for access.

All workflows are located in the `.github/workflows` directory. Ensure required secrets are configured in the repository settings for workflows to function correctly.
<!-- AI:end:ci -->

## Mirror chain

<!-- AI:start:mirror-chain -->
This repo is maintained in [`Interested-Deving-1896/penguins-recovery`](https://github.com/Interested-Deving-1896/penguins-recovery) and mirrored through:

```
Interested-Deving-1896/penguins-recovery  ──►  OpenOS-Project-OSP/penguins-recovery  ──►  OpenOS-Project-Ecosystem-OOC/penguins-recovery
```

Changes flow downstream automatically via the hourly mirror chain in
[`fork-sync-all`](https://github.com/Interested-Deving-1896/fork-sync-all).
Direct commits to OSP or OOC are detected and opened as PRs back to `Interested-Deving-1896`.
<!-- AI:end:mirror-chain -->

## Contributors

<!-- AI:start:contributors -->
[@Interested-Deving-1896](https://github.com/Interested-Deving-1896): 73 commits  
[@github-actions[bot]](https://github.com/github-actions[bot]): 8 commits  
[@ona-agent](https://github.com/ona-agent): 1 commit  

*Note: This repository may be a mirror. Please check the upstream source for additional details.*
<!-- AI:end:contributors -->

## Origins

<!-- AI:start:origins -->
_Original project — no upstream fork._
<!-- AI:end:origins -->

## Resources

<!-- AI:start:resources -->
_No additional resource files found._
<!-- AI:end:resources -->

## License

<!-- AI:start:license -->
<!-- License not detected — add a LICENSE file to this repo. -->
<!-- AI:end:license -->
