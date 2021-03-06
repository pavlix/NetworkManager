libnm_inc = include_directories('.')

sources = files('nm-libnm-utils.c')

if have_fake_typelibs
  subdir('fake-typelib')
endif

incs = [
  top_inc,
  shared_inc,
  libnm_core_inc
]

deps = [
  # FIXME: this makes GIR mandatory?
  gir_dep,
  glib_dep,
  libnmdbus_dep
]

cflags = [
  '-DG_LOG_DOMAIN="libnm"',
  '-DNETWORKMANAGER_COMPILATION=NM_NETWORKMANAGER_COMPILATION_LIB',
  '-DNMRUNDIR="@0@"'.format(nm_pkgrundir)
]

libnm_utils = static_library(
  'nm-utils',
  sources: sources,
  include_directories: incs,
  dependencies: deps,
  c_args: cflags
)

libnm_headers = files(
  'NetworkManager.h',
  'nm-access-point.h',
  'nm-active-connection.h',
  'nm-checkpoint.h',
  'nm-client.h',
  'nm-device-adsl.h',
  'nm-device-bond.h',
  'nm-device-bridge.h',
  'nm-device-bt.h',
  'nm-device-dummy.h',
  'nm-device-ethernet.h',
  'nm-device-generic.h',
  'nm-device.h',
  'nm-device-infiniband.h',
  'nm-device-ip-tunnel.h',
  'nm-device-macsec.h',
  'nm-device-macvlan.h',
  'nm-device-modem.h',
  'nm-device-olpc-mesh.h',
  'nm-device-ovs-interface.h',
  'nm-device-ovs-port.h',
  'nm-device-ovs-bridge.h',
  'nm-device-ppp.h',
  'nm-device-team.h',
  'nm-device-tun.h',
  'nm-device-vlan.h',
  'nm-device-vxlan.h',
  'nm-device-wifi.h',
  'nm-device-wimax.h',
  'nm-dhcp-config.h',
  'nm-ip-config.h',
  'nm-object.h',
  'nm-remote-connection.h',
  'nm-secret-agent-old.h',
  'nm-types.h',
  'nm-vpn-connection.h',
  'nm-vpn-editor.h',
  'nm-vpn-plugin-old.h',
  'nm-vpn-service-plugin.h',
  'nm-wimax-nsp.h'
)

install_headers(
  libnm_core_headers + libnm_headers + [version_header],
  subdir: 'libnm'
)

enum_headers = libnm_headers + [version_header]
enum_types = 'nm-enum-types'

libnm_enum = gnome.mkenums(
  enum_types,
  sources: enum_headers,
  identifier_prefix: nm_id_prefix,
  c_template: enum_types + '.c.template',
  h_template: enum_types + '.h.template',
  install_header: true,
  install_dir: libnm_pkgincludedir
)

libnm_sources = files(
  'nm-access-point.c',
  'nm-active-connection.c',
  'nm-checkpoint.c',
  'nm-client.c',
  'nm-dbus-helpers.c',
  'nm-device-adsl.c',
  'nm-device-bond.c',
  'nm-device-bridge.c',
  'nm-device-bt.c',
  'nm-device.c',
  'nm-device-dummy.c',
  'nm-device-ethernet.c',
  'nm-device-generic.c',
  'nm-device-infiniband.c',
  'nm-device-ip-tunnel.c',
  'nm-device-macsec.c',
  'nm-device-macvlan.c',
  'nm-device-modem.c',
  'nm-device-olpc-mesh.c',
  'nm-device-ovs-interface.c',
  'nm-device-ovs-port.c',
  'nm-device-ovs-bridge.c',
  'nm-device-ppp.c',
  'nm-device-team.c',
  'nm-device-tun.c',
  'nm-device-vlan.c',
  'nm-device-vxlan.c',
  'nm-device-wifi.c',
  'nm-device-wimax.c',
  'nm-dhcp-config.c',
  'nm-dhcp4-config.c',
  'nm-dhcp6-config.c',
  'nm-dns-manager.c',
  'nm-ip-config.c',
  'nm-ip4-config.c',
  'nm-ip6-config.c',
  'nm-manager.c',
  'nm-object.c',
  'nm-remote-connection.c',
  'nm-remote-settings.c',
  'nm-secret-agent-old.c',
  'nm-vpn-connection.c',
  'nm-vpn-plugin-old.c',
  'nm-vpn-editor.c',
  'nm-vpn-service-plugin.c',
  'nm-wimax-nsp.c'
)

deps = [
  dl_dep,
  glib_dep,
  libudev_dep,
  uuid_dep
]

symbol_map = join_paths(meson.current_source_dir(), 'libnm.ver')

ldflags = []
if have_version_script
  ldflags += '-Wl,--version-script,@0@'.format(symbol_map)
endif

libnm = shared_library(
  'nm',
  sources: libnm_sources + libnm_enum,
  version: libnm_version,
  include_directories: incs + [libnm_core_inc],
  dependencies: deps,
  c_args: cflags,
  link_with: libnm_utils,
  link_whole: libnm_core,
  link_args: ldflags,
  link_depends: symbol_map,
  install: true,
  install_dir: get_option('libdir')
)

libnm_dep = declare_dependency(
  link_with: libnm,
  include_directories: libnm_inc
)

pkg.generate(
  libraries: libnm,
  version: nm_version,
  name: 'libnm',
  description: 'Convenience library for clients of NetworkManager',
  filebase: 'libnm',
  subdirs: 'libnm',
  requires: 'gio-2.0',
  variables: [
    'exec_prefix=${prefix}',
    'vpnservicedir=' + join_paths(nm_pkglibdir, 'VPN')
  ],
  install_dir: join_paths(nm_libdir, 'pkgconfig')
)

run_target(
  'check-local-exports-libnm',
  command: [check_exports, libnm.full_path(), symbol_map],
  depends: libnm
)

if enable_introspection
  gir_sources = libnm_core_enum + libnm_core_headers + libnm_core_sources + libnm_enum + libnm_headers + libnm_sources + [version_header]

  gir_dir = join_paths(nm_datadir, 'gir-' + nm_gir_version)
  typelib_dir = join_paths(nm_libdir, 'girepository-' + nm_gir_version)

  libnm_gir = gnome.generate_gir(
    libnm,
    sources: gir_sources,
    nsversion: nm_gir_version,
    namespace: 'NM',
    identifier_prefix: nm_id_prefix,
    symbol_prefix: nm_id_prefix.to_lower(),
    export_packages: 'libnm',
    includes: 'Gio-2.0',
    extra_args: cflags,
    install: true,
    install_dir_gir: gir_dir,
    install_dir_typelib: typelib_dir
  )

  generate_plugin_docs = join_paths(meson.current_source_dir(), 'generate-plugin-docs.pl')

  name = 'nm-settings-keyfile-docs.xml'
  nm_settings_keyfile_docs = custom_target(
    name,
    input: libnm_core_settings_sources,
    output: name,
    command: [perl, generate_plugin_docs, 'keyfile', '@OUTPUT@', '@INPUT@']
  )

  name = 'nm-settings-docs-overrides.xml'
  nm_settings_docs_overrides = custom_target(
    name,
    input: libnm_core_settings_sources,
    output: name,
    command: [perl, generate_plugin_docs, 'dbus', '@OUTPUT@', '@INPUT@']
  )

  if enable_ifcfg_rh
    name = 'nm-settings-ifcfg-rh-docs.xml'
    nm_settings_ifcfg_rh_docs = custom_target(
      name,
      input: libnm_core_settings_sources,
      output: name,
      command: [perl, generate_plugin_docs, 'ifcfg-rh', '@OUTPUT@', '@INPUT@']
    )
  endif

  generate_setting_docs = join_paths(meson.current_source_dir(), 'generate-setting-docs.py')

  name = 'nm-property-docs.xml'
  nm_property_docs = custom_target(
    name,
    input: libnm_gir[0],
    output: name,
    command: [generate_setting_docs, '--lib-path', meson.current_build_dir(), '--gir', '@INPUT@', '--output', '@OUTPUT@'],
    depends: libnm
  )

  name = 'nm-settings-docs.xml'
  nm_settings_docs = custom_target(
    name,
    input: libnm_gir[0],
    output: name,
    command: [generate_setting_docs, '--lib-path', meson.current_build_dir(), '--gir', '@INPUT@', '--overrides', nm_settings_docs_overrides, '--output', '@OUTPUT@'],
    depends: libnm
  )
endif

if enable_tests
  subdir('tests')
endif
