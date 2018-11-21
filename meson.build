project('com.github.nine-h.sesh', 'vala', 'c', version:'0.1')

add_project_arguments(['--vapidir', join_paths(meson.current_source_dir(), 'vapi')], language: 'vala')

app_deps = [
    dependency('granite'),
    dependency('gtk+-3.0'),
    dependency('gdk-3.0'),
    dependency('epoxy'),
    dependency('gstreamer-1.0'),
    meson.get_compiler('vala').find_library('posix'),
    meson.get_compiler('c').find_library('m'),
    meson.get_compiler('c').find_library('epoxy')
]

app_source = files(
    'src/demoswitcher.vala',
    'src/sesh.vala',
    'src/window.vala',
    'src/fft_streamer.vala',
    'src/graphics.vala'
)

app = executable (
    meson.project_name(),
    app_source,
    dependencies: app_deps,
    install: true
)
