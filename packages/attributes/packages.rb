# Toggle for recipes to determine if we should rely on distribution packages
# or gems.
set_unless[:packages][:dist_only] = false

set_unless[:extra_packages] = {}
