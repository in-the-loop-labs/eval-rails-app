# SPDX-License-Identifier: MIT
# frozen_string_literal: true

class ProjectsController < ApplicationController
  include Paginatable

  before_action :set_project, only: %i[show edit update destroy]

  def index
    authorize Project

    scope = policy_scope(Project).recently_updated
    scope = scope.search(params[:q]) if params[:q].present?

    @projects = paginate(scope, per_page: params[:per_page] || 10)
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

    scope = policy_scope(Project).archived.recently_updated
    @projects = paginate(scope, per_page: params[:per_page] || 10)

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
