<% if namespaced? -%>
require_dependency "<%= namespaced_path %>/application_controller"

<% end -%>
<% module_namespacing do -%>
class <%= controller_class_name %>Controller < ApplicationController

  # GET <%= route_url %>
  def index
    load_<%= plural_table_name %>
  end

  # GET <%= route_url %>/1
  def show
    load_<%= singular_table_name %>
  end

  # GET <%= route_url %>/new
  def new
    build_<%= singular_table_name %>
  end

  # GET <%= route_url %>/1/edit
  def edit
    load_<%= singular_table_name %>
  end

  # POST <%= route_url %>
  def create
    build_<%= singular_table_name %>

    if @<%= orm_instance.save %>
      redirect_to @<%= singular_table_name %>, notice: <%= "'#{human_name} was successfully created.'" %>
    else
      render :new
    end
  end

  # PATCH/PUT <%= route_url %>/1
  def update
    load_<%= singular_table_name %>
    build_<%= singular_table_name %>

    if @<%= orm_instance.save %>
      redirect_to @<%= singular_table_name %>, notice: <%= "'#{human_name} was successfully updated.'" %>
    else
      render :edit
    end
  end

  # DELETE <%= route_url %>/1
  def destroy
    load_<%= singular_table_name %>

    @<%= orm_instance.destroy %>
    redirect_to <%= index_helper %>_url, notice: <%= "'#{human_name} was successfully destroyed.'" %>
  end

  private
    def load_<%= plural_table_name %>
      @<%= plural_table_name %> ||= <%= singular_table_name %>_scope.to_a
    end

    def load_<%= singular_table_name %>
      @<%= singular_table_name %> ||= <%= singular_table_name %>_scope.where(:id => params[:id]).first
    end

    def build_<%= singular_table_name %>
      @<%= singular_table_name %> ||= <%= singular_table_name %>_scope.build
      @<%= singular_table_name %>.attributes = <%= singular_table_name %>_params
    end

    # Only allow a trusted parameter "white list" through.
    def <%= "#{singular_table_name}_params" %>
      (params[:<%= singular_table_name %>] || ActionController::Parameters.new).permit(
      <%- if attributes_names.empty? -%>
        # add some permitted parameters
      <%- else -%>
        <%= attributes_names.map { |name| ":#{name}" }.join(', ') %>
      <%- end -%>
      )
    end

    def <%= singular_table_name %>_scope
      <%= class_name %>.where(nil)
    end
end
<% end -%>
