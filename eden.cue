package todoapp

import (
	"dagger.io/dagger"
	"universe.dagger.io/bash"
	"universe.dagger.io/docker"
)

dagger.#Plan & {
	client: {
		filesystem: {
			"./": read: {
				contents: dagger.#FS
				exclude: [
					"README.md",
					"eden.cue",
				]
			}
		}
		env: {
			APP_NAME:      string
			NETLIFY_TEAM:  string
			NETLIFY_TOKEN: dagger.#Secret
		}
	}
	actions: {
		deps: {
			build:
				docker.#Build & {
					steps: [
						docker.#Pull & {
							source: "index.docker.io/node"
						},
						docker.#Copy & {
							contents: client.filesystem."./".read.contents
							dest:     "./src"
						},
					]
				}
			gitleaks:
				docker.#Build & {
					steps: [
						docker.#Pull & {
							source: "index.docker.io/zricethezav/gitleaks"
						},
						docker.#Copy & {
							contents: client.filesystem."./".read.contents
							dest:     "./src"
						},
					]
				}
			postgres:
				docker.#Build & {
					steps: [
						docker.#Pull & {
							source: "index.docker.io/postgres"
						},
					]
				}
		}

		build: {
			bash.#Run & {
				workdir: "./src"
				input:   deps.build.output
				script: contents: #"""
					npm ci
					"""#
			}
		}

		staticAnalysis: {
			lint:
				bash.#Run & {
					workdir: "./src"
					input:   build.output
					script: contents: #"""
						npx eslint --color .
						"""#
				}
			sonarscanner:
				bash.#Run & {
					workdir: "./src"
					input:   build.output
					script: contents: #"""
						echo 'This needs setting up'
						"""#
				}
		}

		test: {
			integrationTest: {
				workdir: "./src"
				docker.#Run & {
					input: build.output
					command: {
						name: "/bin/bash"
						args: ["-c", "npm run test:ci"]
					}
				}
			}
		}

		SCA: {
			secretDetection: {
				docker.#Run & {
					workdir: "./src"
					input:   deps.gitleaks.output
					command: {
						name: "detect"
					}
				}
			}
			dependencyScanning: {
				docker.#Run & {
					workdir: "./src"
					input:   build.output
					command: {
						name: "/bin/bash"
						args: ["-c", "npx audit-ci --high"]
					}
				}
			}
		}
	}
}
