var backgroundimageprocess = {
	uploadPhotos: function(success, fail, params){
		cordova.exec(success, fail, "BackgroundImageProcess", "uploadPhotos",params);
	},
    downloadPhotos: function(success, fail, params){
        cordova.exec(success, fail, "BackgroundImageProcess", "downloadDocuments",params);
    }
}

module.exports = backgroundimageprocess;