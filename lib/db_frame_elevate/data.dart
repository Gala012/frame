import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'db_frame_elevate_entity.dart';
class FrameElevateDB extends GetxService {
  static FrameElevateDB get to => Get.find();
  Database? _db;
  Future<FrameElevateDB> init() async {
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      join(dbPath, 'frame_elevate.db'),
      version: 2,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return this;
  }
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE artworks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        thumbnail_path TEXT NOT NULL,
        output_path TEXT NOT NULL,
        feature_type TEXT NOT NULL,
        created_at TEXT NOT NULL,
        output_width INTEGER,
        output_height INTEGER
      )
    ''');
    await db.execute('''
      CREATE TABLE artwork_sources (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        artwork_id INTEGER NOT NULL,
        source_path TEXT NOT NULL,
        crop_x REAL,
        crop_y REAL,
        crop_width REAL,
        crop_height REAL,
        rotation INTEGER,
        sort_order INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY (artwork_id) REFERENCES artworks(id) ON DELETE CASCADE
      )
    ''');
    await db.execute('''
      CREATE TABLE artwork_params (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        artwork_id INTEGER NOT NULL UNIQUE,
        frame_id TEXT,
        frame_width TEXT,
        mat_size TEXT,
        mat_color TEXT,
        mat_texture TEXT,
        bg_type TEXT,
        bg_value TEXT,
        filter_id TEXT,
        filter_intensity REAL,
        scene_id TEXT,
        scene_size TEXT,
        sig_style TEXT,
        sig_artist TEXT,
        sig_title TEXT,
        sig_year TEXT,
        sig_medium TEXT,
        sig_size TEXT,
        sig_x REAL,
        sig_y REAL,
        template_id TEXT,
        layout_id TEXT,
        FOREIGN KEY (artwork_id) REFERENCES artworks(id) ON DELETE CASCADE
      )
    ''');
  }
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE artworks ADD COLUMN output_width INTEGER');
      await db.execute('ALTER TABLE artworks ADD COLUMN output_height INTEGER');
    }
  }
  Future<int> insertArtwork(ArtworkEntity entity) async {
    try {
      return await _db!.insert('artworks', entity.toMap());
    } catch (e) {
      rethrow;
    }
  }
  Future<List<ArtworkEntity>> getArtworks() async {
    try {
      final maps = await _db!.query(
        'artworks',
        orderBy: 'created_at DESC, id DESC',
      );
      return maps.map((m) => ArtworkEntity.fromMap(m)).toList();
    } catch (e) {
      return [];
    }
  }
  Future<ArtworkEntity?> getArtwork(int id) async {
    try {
      final maps = await _db!.query(
        'artworks',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (maps.isEmpty) return null;
      return ArtworkEntity.fromMap(maps.first);
    } catch (e) {
      return null;
    }
  }
  Future<int> deleteArtwork(int id) async {
    try {
      return await _db!.delete(
        'artworks',
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      return 0;
    }
  }
  Future<void> deleteAllArtworks() async {
    try {
      await _db!.delete('artworks');
    } catch (e) {
      rethrow;
    }
  }
  Future<int> insertArtworkSource(ArtworkSourceEntity entity) async {
    try {
      return await _db!.insert('artwork_sources', entity.toMap());
    } catch (e) {
      rethrow;
    }
  }
  Future<List<ArtworkSourceEntity>> getArtworkSources(int artworkId) async {
    try {
      final maps = await _db!.query(
        'artwork_sources',
        where: 'artwork_id = ?',
        whereArgs: [artworkId],
        orderBy: 'sort_order ASC',
      );
      return maps.map((m) => ArtworkSourceEntity.fromMap(m)).toList();
    } catch (e) {
      return [];
    }
  }
  Future<int> updateArtworkSource(ArtworkSourceEntity entity) async {
    try {
      return await _db!.update(
        'artwork_sources',
        entity.toMap(),
        where: 'id = ?',
        whereArgs: [entity.id],
      );
    } catch (e) {
      return 0;
    }
  }
  Future<int> insertArtworkParams(ArtworkParamsEntity entity) async {
    try {
      return await _db!.insert('artwork_params', entity.toMap());
    } catch (e) {
      rethrow;
    }
  }
  Future<ArtworkParamsEntity?> getArtworkParams(int artworkId) async {
    try {
      final maps = await _db!.query(
        'artwork_params',
        where: 'artwork_id = ?',
        whereArgs: [artworkId],
      );
      if (maps.isEmpty) return null;
      return ArtworkParamsEntity.fromMap(maps.first);
    } catch (e) {
      return null;
    }
  }
  Future<int> updateArtworkParams(ArtworkParamsEntity entity) async {
    try {
      return await _db!.update(
        'artwork_params',
        entity.toMap(),
        where: 'artwork_id = ?',
        whereArgs: [entity.artworkId],
      );
    } catch (e) {
      return 0;
    }
  }
}
