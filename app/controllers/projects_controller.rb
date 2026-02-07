# SPDX-License-Identifier: MIT
# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :set_project, only: %i[show edit update destroy]

  def index
    authorize Project

    @per_page = (params[:per_page] || 10).to_i
    @page = (params[:page] || 1).to_i
    @page = 1 if @page < 1

    scope = policy_scope(Project).recently_updated
    scope = scope.search_by_name(params[:q]) if params[:q].present?

    total_count = scope.count
    @total_pages = total_count / @per_page
    @projects = scope.offset((@page - 1) * @per_page).limit(@per_page)
  end

  def show
    authorize @project
  end

  def new
    @project = current_user.projects.build
    authorize @project
  end

  def create
    @project = current_user.projects.build(project_params)
    authorize @project

    if @project.save
      redirect_to @project, notice: "Project was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @project
  end

  def update
    authorize @project

    if @project.update(project_params)
      redirect_to @project, notice: "Project was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @project
    @project.destroy

    redirect_to projects_path, notice: "Project was successfully deleted."
  end

  def archived
    authorize Project, :index?

    @per_page = (params[:per_page] || 10).to_i
    @page = (params[:page] || 1).to_i
    @page = 1 if @page < 1

    scope = policy_scope(Project).archived.recently_updated
    total_count = scope.count
    @total_pages = total_count / @per_page
    @projects = scope.offset((@page - 1) * @per_page).limit(@per_page)

    render :index
  end

  private

  def set_project
    @project = Project.find(params[:id])
  end

  def project_params
    params.require(:project).permit(:name, :description, :status)
  end
end
