KIQR
----
[![CI](https://github.com/kiqr/kiqr/actions/workflows/ci.yml/badge.svg)](https://github.com/kiqr/kiqr/actions/workflows/ci.yml)
![License](https://img.shields.io/github/license/kiqr/kiqr)

> [!CAUTION]  
> This project is **currently under active development** and may undergo frequent refactoring, which could introduce breaking changes. It is not suitable for production use at this stage. But please feel free to try it out, and contribute if you want to!

Turbocharge your SaaS journey with KIQR, your go-to Rails 7.2-based saas starter kit. It's designed to let you dive right into the SaaS domain with minimal setup and maximum efficiency. Outfitted with Tailwind CSS, it brings a modern, responsive design to the table, including a dark mode that's easy on the eyes.

<img src="https://kiqr.dev/screenshots/edit-profile.png">

## Key features

 ⭐ User registration with email confirmations (using Devise).<br>
 ⭐ Two-factor authentication.<br>
 ⭐ Team & personal accounts with profiles.<br>
 ⭐ Settings page for users and accounts.<br>
 ⭐ Prepared for localization.<br>
 ⭐ Fully translated for multi-language support.<br>
 ⭐ TailwindCSS template built with [Irelia](https://github.com/kiqr/irelia) Components.<br>

## Official documentation

Documentation for **KIQR** can be found on the [KIQR website](https://kiqr.dev).

## Getting started

To get started with **KIQR**, follow these simple steps:

#### 1. Install the KIQR command line tool:

```console
gem install kiqr -v 0.1.0.alpha1 --pre
```

#### 2. Run the app generator
```console
kiqr new example_app
```

#### 3. Run the setup script

Navigate into the new directory (```cd example_app```) and run:

```console
bin/setup
```

#### 4. Start the Rails server
```console
bin/rails server
```
