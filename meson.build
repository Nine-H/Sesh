project('com.github.nine-h.sesh', ['vala', 'c'], version: '0.0.0')
executable(
    'com.github.nine-h.sesh',
    'src/settings.vala',
    'src/demoswitcher.vala',
    'src/fft_streamer.vala',
    'src/graphics.vala',
    'src/window.vala',
    'src/sesh.vala',
    dependencies: [
        dependency('gtk+-3.0'),
        dependency('glepoxy'),
        dependency('granite'),
        dependency('gdk-3.0'),
        dependency('gstreamer-1.0')
    ]
)
