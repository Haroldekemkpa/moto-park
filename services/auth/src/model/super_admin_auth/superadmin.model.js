// src/model/super_admin_auth/superadmin.model.js
import bcrypt from 'bcryptjs';

export default (sequelize, DataTypes) => {
  const AuthSuperAdmin = sequelize.define(
    'AuthSuperAdmin',  // ← This is the key — must be exactly 'AuthSuperAdmin'
    {
      id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
      },
      email: {
        type: DataTypes.TEXT,
        allowNull: false,
        unique: true,
        validate: { isEmail: true },
      },
      password_hash: {
        type: DataTypes.TEXT,
        allowNull: false,
        field: 'password_hash',
      },
      is_active: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: true,
      },
      email_verified: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: false,
        field: 'email_verified',
      },
      failed_login_attempts: {
        type: DataTypes.INTEGER,
        defaultValue: 0,
      },
      locked_until: {
        type: DataTypes.DATE,
        allowNull: true,
      },
      last_failed_attempt: {
        type: DataTypes.DATE,
        allowNull: true,
      },
      last_login: {
        type: DataTypes.DATE,
        allowNull: true,
      },
    },
    {
      tableName: 'auth_superadmins',
      timestamps: true,
      createdAt: 'created_at',
      updatedAt: 'updated_at',
      hooks: {
        beforeCreate: async (admin) => {
          if (admin.password_hash) {
            const salt = await bcrypt.genSalt(12);
            admin.password_hash = await bcrypt.hash(admin.password_hash, salt);
          }
        },
        beforeUpdate: async (admin) => {
          if (admin.changed('password_hash') && admin.password_hash) {
            const salt = await bcrypt.genSalt(12);
            admin.password_hash = await bcrypt.hash(admin.password_hash, salt);
          }
        },
      },
    }
  );

  AuthSuperAdmin.prototype.comparePassword = async function (password) {
    if (!this.password_hash) return false;
    return bcrypt.compare(password, this.password_hash);
  };

  AuthSuperAdmin.associate = (models) => {
    AuthSuperAdmin.hasMany(models.AuthSuperAdminRefreshToken, {
      foreignKey: 'superadmin_id',
      as: 'refresh_tokens',
      onDelete: 'CASCADE',
    });
  };

  return AuthSuperAdmin;
};