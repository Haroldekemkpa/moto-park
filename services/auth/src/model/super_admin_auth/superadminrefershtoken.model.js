// src/model/super_admin_auth/superadminrefershtoken.model.js
export default (sequelize, DataTypes) => {
  const AuthSuperAdminRefreshToken = sequelize.define(
    'AuthSuperAdminRefreshToken',  // ← Must be exactly this
    {
      id: {
        type: DataTypes.UUID,
        defaultValue: DataTypes.UUIDV4,
        primaryKey: true,
      },
      token: {
        type: DataTypes.TEXT,
        allowNull: false,
      },
      expires_at: {
        type: DataTypes.DATE,
        allowNull: false,
      },
      revoked: {
        type: DataTypes.BOOLEAN,
        allowNull: false,
        defaultValue: false,
      },
    },
    {
      tableName: 'auth_superadmin_refresh_tokens',
      timestamps: true,
      createdAt: 'created_at',
      updatedAt: false,
    }
  );

  AuthSuperAdminRefreshToken.associate = (models) => {
    AuthSuperAdminRefreshToken.belongsTo(models.AuthSuperAdmin, {
      foreignKey: 'superadmin_id',
      as: 'superadmin',
    });
  };

  return AuthSuperAdminRefreshToken;
};