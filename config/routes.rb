# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

resource :kanbine, only: :none do
  post 'issues/update_status_position', to: 'kanbine/issues#update_status_position'
end

get 'projects/:id/kanban', to: 'kanban#show'
