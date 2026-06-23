#!/bin/bash
# Makefile for Techizat OS project

.PHONY: help setup build install clean test

help:
	@echo "═══════════════════════════════════════════════════════════════"
	@echo "   🦉 TECHIZAT OS - Makefile Commands"
	@echo "═══════════════════════════════════════════════════════════════"
	@echo ""
	@echo "Available commands:"
	@echo "  make help       - Show this help message"
	@echo "  make setup      - Setup development environment"
	@echo "  make build      - Build ISO image"
	@echo "  make install    - Install theme to system"
	@echo "  make clean      - Clean build artifacts"
	@echo "  make test       - Run tests"
	@echo ""

setup:
	@echo "[*] Setting up development environment..."
	@chmod +x build/setup-dev-env.sh
	@bash build/setup-dev-env.sh

build:
	@echo "[*] Building ISO image..."
	@chmod +x build/build-iso.sh
	@sudo bash build/build-iso.sh

install:
	@echo "[*] Installing theme to system..."
	@chmod +x build/install-theme.sh
	@sudo bash build/install-theme.sh

clean:
	@echo "[*] Cleaning build artifacts..."
	@rm -rf build/output
	@rm -rf build/work
	@rm -rf venv
	@rm -f .DS_Store
	@find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	@echo "[+] Cleanup complete"

test:
	@echo "[*] Running tests..."
	@if command -v shellcheck &> /dev/null; then \
		shellcheck build/*.sh; \
		echo "[+] Shell scripts validated"; \
	else \
		echo "[!] shellcheck not found, install with: sudo apt-get install shellcheck"; \
	fi

.DEFAULT_GOAL := help
