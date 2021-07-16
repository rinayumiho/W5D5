def what_was_that_one_with(those_actors)
  # Find the movies starring all `those_actors` (an array of actor names).
  # Show each movie's title and id.
  Movie.select("movies.id, title")
       .joins(:actors)
       .where("name in (?)", those_actors)
       .group(1)
       .having("COUNT(name) = (?)", those_actors.length)
end

def golden_age
  # Find the decade with the highest average movie score.
    # floor(1962 / 10) * 10
    object = Movie.select("Floor(yr / 10) * 10 AS decade")
                  .group(1)
                  .order("AVG(score) DESC")
    object.first[:decade].to_i
end

def costars(name)
  # List the names of the actors that the named actor has ever
  # appeared with.
  # Hint: use a subquery
  movie_list = Actor.joins(:movies).where("name = (?)", name).pluck(:title)
  Actor.joins(:movies)
       .where("name != (?) and title in (?)", name, movie_list)
       .pluck("DISTINCT name")

end

def actor_out_of_work
  # Find the number of actors in the database who have not appeared in a movie
  Actor.left_outer_joins(:movies).where("title IS NULL").pluck("COUNT(*)")[0]
  # Actor.left_outer_joins(:movies).where("title IS NULL").length

end

def starring(whazzername)
  # Find the movies with an actor who had a name like `whazzername`.
  # A name is like whazzername if the actor's name contains all of the
  # letters in whazzername, ignoring case, in order.

  # ex. "Sylvester Stallone" is like "sylvester" and "lester stone" but
  # not like "stallone sylvester" or "zylvester ztallone"
  # Movie.select("movies.*")
  #      .joins(:actors)
  #      .where(helper(:name.to_s, whazzername))
  #      .group(1)
  #     .having("COUNT(*) = 1")

  actor_list = Actor.where(helper(:name.to_s, whazzername)).pluck(:name)
  Movie.select("DiSTINCT movies.*")
       .joins(:actors)
       .where("actors.name in (?)", actor_list)
end

def helper(str1, str2)
  i, n = 0, str2.length
  str1.each_char { |char| i += 1 if i < n && char.downcase == str2[i].downcase }
  i == n
end

def longest_career
  # Find the 3 actors who had the longest careers
  # (the greatest time between first and last movie).
  # Order by actor names. Show each actor's id, name, and the length of
  # their career.
  Actor.select("actors.id, name, MAX(yr) - MIN(yr) AS career")
        .joins(:movies)
        .group("1,2")
        .order("3 DESC")
        .limit(3)
end

# p helper("Sylvester Stallone", "sylvester")
# p helper("Sylvester Stallone", "lester stone")

# p helper("Sylvester Stallone", "stallone sylvester")
# p helper("Sylvester Stallone", "zylvester ztallone")