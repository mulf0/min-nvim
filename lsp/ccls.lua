return {
  cmd = { 'ccls' },
  filetypes = { 'cuda' },
  root_markers = { 'compile_commands.json', '.git' },
  init_options = {
    compilationDatabaseDirectory = '/home/mulf/cutlass/build',
    cache = { directory = '/tmp/ccls-cache' },
    clang = {
      extraArgs = {
        '--cuda-gpu-arch=sm_90',
        '-I/usr/local/cuda-13.1/include',
        '--cuda-path=/usr/local/cuda-13.1',
      },
    },
  },
}
