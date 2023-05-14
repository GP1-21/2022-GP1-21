from flask import Flask, request, jsonify
import pandas as pd
from sklearn.feature_extraction.text import CountVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import os 

app = Flask(__name__)

# Get the current working directory
cwd = os.getcwd()

# Load the data into a pandas dataframe
data = pd.read_csv(os.path.join(cwd, 'HunaKSAPlaceData.csv'))

# Create a CountVectorizer object to generate the term frequency matrix
cv = CountVectorizer()

# Generate the term frequency matrix
tf_matrix = cv.fit_transform(data['type'])

# Calculate the cosine similarity matrix
cosine_sim = cosine_similarity(tf_matrix)


@app.route('/recommend_interests', methods=['POST'])
def recommend_interests():
    # Get the list of interests from the request body
    interests = request.json.get('interests', [])

    # Create a list of indices for the places that match the user's interests
    indices = []
    for index, row in data.iterrows():
        if any(interest in row['type'] for interest in interests):
            indices.append(index)

    # Create a list of tuples that contain the index and similarity score for each place
    similar_places = []
    for index in indices:
        sim_scores = list(enumerate(cosine_sim[index]))
        sim_scores = sorted(sim_scores, key=lambda x: x[1], reverse=True)
        sim_scores = sim_scores[1:6]
        place_indices = [i[0] for i in sim_scores]
        similar_places.append((index, place_indices))

    # Create a list of recommended places
    recommended_places = []
    for place in similar_places:
        for index in place[1]:
            recommended_places.append(data.iloc[index]['place'])

    return jsonify({'recommended_places': list(set(recommended_places))})

@app.route('/')
def home():
    return 'Run successfully!'


if __name__ == '__main__':
    app.run(debug=True)
