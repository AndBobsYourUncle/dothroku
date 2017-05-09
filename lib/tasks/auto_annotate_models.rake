if Rails.env.development?
  task :set_annotation_options do
    # You can override any of these by setting an environment variable of the
    # same name.
    Annotate.set_defaults({
      'position_in_routes'      => 'before',
      'position_in_class'       => 'before',
      'position_in_test'        => 'before',
      'position_in_fixture'     => 'before',
      'position_in_factory'     => 'before',
      'show_indexes'            => 'false',
      'simple_indexes'          => 'false',
      'model_dir'               => 'app/models',
      'include_version'         => 'false',
      'require'                 => '',
      'exclude_tests'           => 'true',
      'exclude_fixtures'        => 'true',
      'exclude_factories'       => 'true',
      'exclude_controllers'     => 'true',
      'exclude_helpers'         => 'true',
      'exclude_scaffolds'       => 'true',
      'ignore_model_sub_dir'    => 'false',
      'skip_on_db_migrate'      => 'false',
      'format_bare'             => 'true',
      'format_rdoc'             => 'false',
      'format_markdown'         => 'false',
      'sort'                    => 'true',
      'force'                   => 'false',
      'trace'                   => 'false',
      'hide_limit_column_types' => 'true'
    })
  end

  Annotate.load_tasks
end
