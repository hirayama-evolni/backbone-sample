module.exports = function(grunt) {
    grunt.initConfig({
	coffee: {
	    compile: {
                files: {
                    // 全部くっつけてall.jsを作成
                    "js/all.js": [
                        'coffee/address.coffee',
                        'coffee/address_book.coffee',
                        'coffee/form_view.coffee',
                        'coffee/list_view.coffee',
                        'coffee/app.coffee',
                    ]
                }
	    }
	},
        sass: {
            dist: {
                options: {
                    style: 'expanded'
                },
                // main.sass -> main.css
                files: {
                    'css/main.css': 'sass/main.scss'
                }
            }
        },
        hogan: {
            convert: {
                options: {
                    // foo/hogehoge.tmpl -> hogehoge
                    defaultName: function(filename) {
                        return filename.split('/').pop().replace(/\.tmpl$/, '');
                    },
                },
                files: {
                    "js/template.js": ["templates/*.tmpl"]
                }
            }
        },
        watch: {
            scripts: {
                files: ['**/*.coffee'],
                tasks: ['coffee']
            },
            css: {
                files: ['**/*.scss'],
                tasks: ['sass']
            },
            templates: {
                files: ['**/*.tmpl'],
                tasks: ['hogan']
            }
        }
    });

    // タスク追加
    grunt.loadNpmTasks('grunt-contrib-coffee');
    grunt.loadNpmTasks('grunt-contrib-sass');
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.loadNpmTasks('grunt-contrib-hogan');

    // default -> coffee, sass, hogan
    grunt.registerTask('default', ['coffee', 'sass', 'hogan']);
}
