# Workspace Files Summary

This document provides a comprehensive overview of all files in the workspace, detailing their purpose, content, and responsibilities.

## 1. README.md
**Purpose**: Primary documentation file for the containerized OpenCode agent
**Responsibilities**:
- Explains the container setup using Red Hat Universal Base Image Minimal
- Describes the default configuration and runtime behavior
- Provides detailed instructions for building and running the container
- Includes configuration guidelines for vLLM providers and environment variables
- Contains platform-specific run instructions for Linux/macOS and Windows PowerShell
- Details validation procedures and troubleshooting tips

## 2. config.json
**Purpose**: Main configuration file for OpenCode agent
**Responsibilities**:
- Defines the primary and secondary LLM models to use
- Configures enabled providers (vLLM code provider)
- Sets permission controls for edit and bash operations
- Specifies provider configurations including base URLs, API keys, and custom headers
- Defines model-specific properties like tool calling support, attachment handling, and context/output limits

## 3. .gitignore
**Purpose**: Git ignore configuration
**Responsibilities**:
- Excludes the .env file from version control to prevent sensitive data exposure

## 4. .env
**Purpose**: Environment variables file
**Responsibilities**:
- Stores sensitive configuration values including vLLM API endpoints
- Contains API key for authentication with vLLM services
- Defines custom headers for user identification (x-user and x-domain)

## 5. entrypoint.sh
**Purpose**: Container entrypoint script
**Responsibilities**:
- Sets up runtime environment variables and directories
- Handles user identity mapping for proper file permissions
- Resolves and executes commands appropriately
- Ensures proper working directory setup
- Manages user privileges when running as root

## 6. Dockerfile
**Purpose**: Container build configuration
**Responsibilities**:
- Defines the build process for the OpenCode container image
- Specifies base image (UBI Minimal) and required packages
- Downloads and installs OpenCode and ripgrep binaries
- Configures user accounts and directory permissions
- Sets up the entrypoint and default working directory

## 7. config.example.jsonc
**Purpose**: Example configuration file with comments
**Responsibilities**:
- Demonstrates the expected structure for config.json
- Provides detailed comments explaining configuration options
- Shows how to configure both code and vision vLLM providers
- Illustrates model ID placeholders and their usage

## 8. .dockerignore
**Purpose**: Docker ignore configuration
**Responsibilities**:
- Prevents unnecessary files from being included in the Docker image
- Protects sensitive files from being packaged in the container
- Excludes version control directories and log files

## 9. .env.example
**Purpose**: Example environment variables file
**Responsibilities**:
- Demonstrates the required environment variables for the container
- Provides template values for vLLM endpoints and API keys
- Shows how to configure identity headers for LLM API calls
- Includes optional settings for local user ID mapping on Linux systems