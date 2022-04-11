package todoapp

import (
	"dagger.io/dagger"
	"dagger.io/dagger/core"
	"universe.dagger.io/alpine"
	"universe.dagger.io/bash"
	"universe.dagger.io/docker"
	"universe.dagger.io/netlify"
)

dagger.#Plan & {
	_nodeModulesMount: "/src/node_modules": {
		dest:     "/src/node_modules"
		type:     "cache"
		contents: core.#CacheDir & {
			id: "todoapp-modules-cache"
		}

	}
	client: {
		filesystem: {
			"./": read: {
				contents: dagger.#FS
				exclude: [
					"README.md",
					"_build",
					"todoapp.cue",
					"node_modules",
				]
			}
			"./_build": write: contents: actions.build.contents.output
		}
		env: {
			APP_NAME:      string
			NETLIFY_TEAM:  string
			NETLIFY_TOKEN: dagger.#Secret
		}
	}
	actions: {
		deps: docker.#Build & {
			steps: [
				alpine.#Build & {
					packages: {
						bash: {}
						yarn: {}
						git: {}
					}
				},
				docker.#Copy & {
					contents: client.filesystem."./".read.contents
					dest:     "/src"
				},
				bash.#Run & {
					workdir: "/src"
					mounts: {
						"/cache/yarn": {
							dest:     "/cache/yarn"
							type:     "cache"
							contents: core.#CacheDir & {
								id: "todoapp-yarn-cache"
							}
						}
						_nodeModulesMount
					}
					script: contents: #"""
						yarn config set cache-folder /cache/yarn
						yarn install
						"""#
				},
			]
		}
		gitleaks: docker.#Build & {
			steps: [
				docker.#Pull & {
					source: "index.docker.io/zricethezav/gitleaks"
				},
				docker.#Copy & {
					contents: client.filesystem."./".read.contents
					dest:     "/src"
				},
			]
		}

		test: run: {
			input:   gitleaks.output
			workdir: "/src"
			mounts:  _nodeModulesMount

			// Test: run a simple shell command
			simpleShell: {
				run: docker.#Run & {
					input: gitleaks.output
					command: {
						name: "detect"
						// args: ["-c", "echo -n hello world >> /output.txt"]
					}
				}
			}

			//  verify: core.#ReadFile & {
			//   input: gitleaksImage.rootfs
			//   path:  "/output.txt"
			//  }
			//  verify: contents: "hello world"
			// }

			// // Test: export a file
			// exportFile: {
			//  run: docker.#Run & {
			//   input: deps.output
			//   command: {
			//    name: "sh"
			//    flags: "-c": #"""
			//    ls /src >> /output.txt
			//    """#
			//   }
			//   export: files: "/output.txt": string & "hello world"
			//  }
			// }

			// // Test: export a directory
			// exportDirectory: {
			//  run: docker.#Run & {
			//   input: deps.output
			//   export: directories: "/src": _
			//  }

			//  verify: core.#ReadFile & {
			//   input: run.export.directories."/src"
			//   path:  "/yarn.lock"
			//  }
			//  verify: contents: "hello world"
			// }

			// // Test: configs overriding image defaults
			// configs: {
			//  _base: docker.#Set & {
			//   input: deps.output
			//   config: {
			//    user:    "nobody"
			//    workdir: "/sbin"
			//    entrypoint: ["sh"]
			//    cmd: ["-c", "echo -n $0 $PWD $(whoami) > /tmp/output.txt"]
			//   }
			//  }

			//  // check defaults not overriden by image config
			//  runDefaults: docker.#Run & {
			//   input: deps.output
			//   command: {
			//    name: "sh"
			//    flags: "-c": "echo -n $PWD $(whoami) > /output.txt"
			//   }
			//   export: files: "/output.txt": "/ root"
			//  }

			//  // check image defaults
			//  imageDefaults: docker.#Run & {
			//   input: _base.output
			//   export: files: "/tmp/output.txt": "sh /sbin nobody"
			//  }

			//  // check overrides by user
			//  overrides: docker.#Run & {
			//   input: _base.output
			//   entrypoint: ["bash"]
			//   workdir: "/root"
			//   user:    "root"
			//   export: files: "/tmp/output.txt": "bash /root root"
			//  }
			// }
		}

		build: {
			run: bash.#Run & {
				input:   test.output
				mounts:  _nodeModulesMount
				workdir: "/src"
				script: contents: #"""
					yarn run build
					"""#
			}

			contents: core.#Subdir & {
				input: run.output.rootfs
				path:  "/src/build"
			}
		}

		deploy: netlify.#Deploy & {
			contents: build.contents.output
			site:     client.env.APP_NAME
			token:    client.env.NETLIFY_TOKEN
			team:     client.env.NETLIFY_TEAM
		}
	}
}
