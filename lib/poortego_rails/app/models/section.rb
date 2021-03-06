###
#
# Section ActiveRecord -
# A piece of a project, or separate investigation under a project umbrella
# e.g., you may want to run different transforms or something on different pieces
#                          
# Attributes:              
#  title:        string    
#  description:  text       
#  project_id:   reference 
#                          
###
class Section < ActiveRecord::Base
  validates :title, :presence => true
  validates :project_id, :presence => true

  belongs_to :project
  has_many :entities
  has_many :links
  
  #
  # List
  #
  def self.list(*args)
    section_rows = Array.new()
    begin
      project_id = args[0]
      section_rows = self.find(:all, :conditions => { :project_id => project_id }, :order => "title ASC")
    rescue Exception => e
      puts "Exception listing Sections"
      puts self.inspect
      puts e.message
    end
    return section_rows    
  end
  
  #
  # Select
  #
  def self.select(*args)
    section_row = nil    
    begin
      project_id   = args[0]
      section_name = args[1]
      section_row  = self.find(:first, :conditions => { :title => section_name, :project_id => project_id })
    rescue Exception => e
      puts "Exception selecting Section"
      puts self.inspect
      puts e.message
    end
    return section_row
  end
  
  #
  # Insert
  #
  def self.insert(*args)
    section_row = nil
    begin
      project_id   = args[0]
      section_name = args[1]
      section_row  = self.new("title" => section_name, "project_id" => project_id.to_i)
      section_row.save()
      puts "[DEBUG] INSERTED section with title #{section_name}, Id = #{section_row.id}"
    rescue Exception => e
      puts "Exception inserting Section"
      puts self.inspect
      puts e.message
    end
    return section_row
  end
  
  #
  # Select if exists, otherwise insert
  #
  def self.select_or_insert(*args)
    section_row = nil
    begin
      project_id   = args[0]
      section_name = args[1]  
      section_row  = self.select(project_id, section_name)
      if (section_row.nil?)
        section_row = self.insert(project_id, section_name)
      end
    rescue Exception => e
      puts "Exception selecting/inserting Section"
      puts self.inspect
      puts e.message
    end
    return section_row    
  end
  
  #
  # Delete Section by name
  #
  def self.delete_from_name(*args)
    section_row = nil
    begin
      project_id   = args[0]
      section_name = args[1]  
      section_row  = self.select(project_id, section_name)
      unless (section_row.nil?)
        self.delete(section_row.id)
        puts "[DEBUG] DELETED section with title #{section_name}, Id = #{section_row.id}"
      else
        puts "[DEBUG] Nothing found with that name, so nothing deleted."
      end
    rescue Exception => e
      puts "Exception deleting Section"
      puts self.inspect
      puts e.message
    end
    return section_row
  end
  
end
